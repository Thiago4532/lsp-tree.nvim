local vim = vim
local api = vim.api
local lt = require'lsp-tree'
local util = require'lsp-tree.util'

local M = {}

M.methods = {
    outer_function = function()
        local symbol, err = lt.symbol.cursor_function_sym(0, cursor_pos)
        if symbol then
            return symbol.range
        end

        return nil, err or "outer_function: invalid symbol"
    end
}

M.select_range = function(keymap_mode, range)
    if range then
        util.update_selection(0, range, util.detect_selection_mode(keymap_mode))
    else
        print('select_range: invalid range')
    end
end

local function call_method(method_name)
    local method = M.selections[method_name]
    if not method then
        return nil, "call_method: select method was not found"
    end

    return method()
end

M.select_from_method = function(keymap_mode, method_name)
    local range, err = call_selection(method_name)
    if range then
        return M.select_range(keymap_mode, range)
    else
        print(err or 'select_from_method: unknown error')
    end
end

local map_opts = { silent = true, noremap = true }
M.buf_map_method = function(bufnr, key, method_name)
    api.nvim_buf_set_keymap(bufnr, 'x', key, string.format(":lua require'lsp-tree'.select.select_from_selection('x', '%s')<CR>", selection_name), map_opts)
    api.nvim_buf_set_keymap(bufnr, 'o', key, string.format(":lua require'lsp-tree'.select.select_from_selection('o', '%s')<CR>", selection_name), map_opts)
end

return M
