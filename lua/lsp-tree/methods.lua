local vim = vim
local api = vim.api
local lt = require'lsp-tree'
local util = require'lsp-tree.util'

local M = {}

M.hover_current_function = function()
    local symbol,err = lt.symbol.cursor_function_sym()
    if not symbol then
        print(err or 'hover_current_function: unknown error')
        return nil
    end

    local range = symbol.selection_range
    if not range then
        print('hover_current_function: invalid selection_range')
        return nil
    end

    local params = {}
    params.textDocument = vim.lsp.util.make_text_document_params()
    params.position = {
        line = range['start'].line - 1,
        character = range['start'].character
    }

    vim.lsp.buf_request(0, 'textDocument/hover', params)
end


return M
