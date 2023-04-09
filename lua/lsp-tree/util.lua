local vim = vim
local api = vim.api
local fn = vim.fn
local protocol = vim.lsp.protocol

local M = {}

M.err_message = function(...)
    api.nvim_err_writeln(table.concat(vim.tbl_flatten{...}))
    api.nvim_command("redraw")
end

M.script_path = function()
    local str = debug.getinfo(2, 'S').source:sub(2)
    return str:match '(.*[/\\])'
end

M.in_range = function(pos, range)
    local line = pos[1]
    local char = pos[2]
    if line < range.start.line or line > range['end'].line then return false end
    if
        line == range.start.line and char < range.start.character or
        line == range['end'].line and char > range['end'].character
    then
        return false
    end

    return true
end

local function extract_symbols(items, _result)
    local result = _result or {}
    if items == nil then return result end
    for _, item in ipairs(items) do
        local kind = protocol.SymbolKind[item.kind] or 'Unknown'
        local sym_range = nil
        local sym_selection_range = nil

        if item.location then -- Item is a SymbolInformation
            return nil
        elseif item.range then
            sym_range = item.range
            sym_selection_range = item.selectionRange
        end

        if sym_range then
            sym_range.start.line = sym_range.start.line + 1
            sym_range['end'].line = sym_range['end'].line + 1
        end

        if sym_selection_range then
            sym_selection_range.start.line = sym_selection_range.start.line + 1
            sym_selection_range['end'].line = sym_selection_range['end'].line + 1
        end

        table.insert(result, {
            range = sym_range,
            selection_range = sym_selection_range,
            kind = kind,
            name = item.name,
        })

        if item.children then
            extract_symbols(item.children, result)
        end
    end

    return result
end
M.extract_symbols = extract_symbols

-- nvim-treesitter-textobjects: /lua/nvim-treesitter/textobjects/select.lua#L19
-- Commit: 31cfd4221b2729a7d4e60a6f1bb506b17af60e87
--
M.detect_selection_mode = function(keymap_mode)
    local selection_mode = "charwise"
    local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)

    -- Update selection mode with different methods based on keymapping mode
    local keymap_to_method = {
        o = "operator-pending",
        s = "visual",
        v = "visual",
        x = "visual",
    }
    local method = keymap_to_method[keymap_mode]

    if method == "visual" then
        selection_mode = fn.visualmode()
    elseif method == "operator-pending" then
        local t = { noV = "linewise" }
        t["no" .. ctrl_v] = "blockwise"
        selection_mode = t[fn.mode(1)]
    end

    return selection_mode
end

M.set_cursor_pos = function(bufnr, pos)
    return fn.setpos('.', { bufnr, pos[1], pos[2] + 1, 0 })
end

-- nvim-treesitter: /lua/nvim-treesitter/ts_utils.lua#L209
-- Commit: 0e25e0e98990803e95c7851236e43b3ee934d443
--
M.update_selection = function(bufnr, range, selection_mode)
    selection_mode = selection_mode or "charwise"
    local top_left = {range['start'].line, range['start'].character}
    local bottom_right = {range['end'].line, range['end'].character - 1}

    local v_table = { charwise = "v", linewise = "V", blockwise = "<C-v>" }
    local mode_string = api.nvim_replace_termcodes(v_table[selection_mode] or selection_mode, true, true, true)

    M.set_cursor_pos(bufnr, top_left)
    vim.cmd('normal! ' .. mode_string)
    M.set_cursor_pos(bufnr, bottom_right)
end

return M
