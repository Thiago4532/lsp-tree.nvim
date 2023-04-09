local vim = vim
local api = vim.api
local lsp_util = vim.lsp.util
local util = require'lsp-tree.util'

local M = {}

-- Method: textDocument/documentSymbol
--

local function_scope_kinds = {
    Function = true,
    Method = true,
    Constructor = true,
}

local function _get_position_symbol(result, pos, filter)
    local extracted_symbols = util.extract_symbols(result)
    if not extracted_symbols then
        return nil
    end

    local filtered_symbols = filter and vim.tbl_filter(filter, extracted_symbols)
                                    or  extracted_symbols

    for i = #filtered_symbols, 1, -1 do
        local sym = filtered_symbols[i]

        if util.in_range(pos, sym.range) then
            return sym
        end
    end
    return nil
end

M.function_sym = function(bufnr, pos)
    local params = { textDocument = lsp_util.make_text_document_params() }

    responses, err = vim.lsp.buf_request_sync(bufnr, 'textDocument/documentSymbol', params)
    if err then
        return nil, err
    end

    local filter = function(sym)
        return function_scope_kinds[sym.kind]
    end

    for _, res in ipairs(responses) do
        if res.result then
            local ret = _get_position_symbol(res.result, pos, filter)
            if ret then
                return ret
            end
        end
    end

    return nil, "function_sym: Not found"
end

M.cursor_function_sym = function()
    local cursor_pos = api.nvim_win_get_cursor(0)
    return M.function_sym(0, cursor_pos)
end

return M
