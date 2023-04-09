local vim = vim
local api = vim.api

local M = setmetatable({}, {
    __index = function(tbl, key)
        local ok, val = pcall(require, string.format('lsp-tree.%s', key)) 
        
        if ok then
            rawset(tbl, key, val)
        end

        return val
    end
})

M.on_attach = function(_, bufnr)
    require'lsp-tree.select'.buf_map_method('af', 'outer_function')
end

M.setup = function()
end

return M
