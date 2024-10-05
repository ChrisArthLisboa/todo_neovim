

local M = {}


local function draw_window()

    local buf = vim.api.nvim_create_buf(true, false)

    local opts = {}
    opts.relative = ''
    opts.width = 10
    opts.height = 10
    opts.col = 10
    opts.row = 1
    opts.style = 'minimal'

    local win = vim.api.nvim_open_win(buf, false, opts)

end


M.draw_window = draw_window


return M
