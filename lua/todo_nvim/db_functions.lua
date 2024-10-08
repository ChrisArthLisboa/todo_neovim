
-- import the sqlite3 module
local sqlite = require("ljsqlite3")
local ui = require("todo_nvim.ui")

local db_path

local M = {}


local function setup_db(db_path_setup)

    if vim.fn.filereadable(db_path_setup .. "/todo.db") == 0 then
        vim.fn.mkdir(db_path_setup, "p")

        local file = io.open(db_path_setup .. "/todo.db", "w+")
    end

    db_path = db_path_setup
    local db_todo = sqlite.open(db_path_setup .. "/todo.db")

    db_todo:exec("create table if not exists tasks (id integer primary key, name text, description text, status text default 'to do', project_code varchar(20) default 'none');")

    db_todo:exec("create table if not exists projects (project_code varchar(20) primary key,name text);")

    db_todo:close()

end


local function fetch_tasks()

    local db = sqlite.open(db_path .. "/todo.db")
    local tasks = {}
    local counter = 0

    local tasksresponded = db:prepare("select tasks.name, tasks.description, tasks.status, projects.name from tasks inner join projects using(project_code);")

    local row = tasksresponded:step()
    while row do
        counter = counter + 1

        tasks[counter] = { name = row[1], description = row[2], status = row[3], project = row[4] }

        row = tasksresponded:step()

    end

    db:close()

    return tasks

end

-- This function is for test purposes only
local function show_tasks()
    ui.draw_window()
    local tasks = fetch_tasks()
    for i, task in ipairs(tasks) do
        print(i .. ". " .. task.name .. " - " .. task.description .. " - " .. task.status .. " - " .. task.project)
    end
end

local function check_for_proj(project_path)

    local db = sqlite.open(db_path .. "/todo.db")
    local proj = db:prepare("select * from projects where project_code = \'"..project_path.."\';")
    local row = proj:step()
    db:close()

    if row then
        return true
    else
        return false
    end

end



local function add_task()
    local db = sqlite.open(db_path .. "/todo.db")

    local name
    local description
    local project_path = vim.fs.root(0, ".git")


    if not check_for_proj(project_path) then
        vim.fn.printf("Project not found, creating a new project")
        local project_name = vim.fn.input("Enter the name of the project: ")
        db:exec("insert into projects (project_code, name) values ('"..project_path.."', '".. project_name .."')")
    end

    repeat
        name = vim.fn.input("Enter the name of the task: ")
        description = vim.fn.input("Enter the description of the task: ")
    until (name ~= "" and description ~= "")

    db:exec("INSERT INTO tasks (name, description, project_code) VALUES (\'"..name.."\', \'"..description.."\', \'"..project_path.."\');")
    db:close()

    vim.fn.printf("\nTask %s added succesfuly", name)


end

local function remove_task()

    local db = sqlite.open(db_path .. "/todo.db")
    local name = vim.fn.input("Enter the name of the task to remove: ")

    db:exec("DELETE FROM tasks WHERE name = \'"..name.."\'")
    db:close()

    vim.fn.printf("\nTask removed successfully")

end

local function complete_task()

    local db = sqlite.open(db_path .. "/todo.db")
    local name = vim.fn.input("Enter the name of the task to complete: ")

    db:exec("UPDATE tasks SET status = 'complete' WHERE name = \'"..name.."\'")
    db:close()

    print("\nTask completed successfully")


end

M.setup_db = setup_db

M.fetch_tasks = show_tasks
M.add_task = add_task
M.remove_task = remove_task
M.complete_task = complete_task

return M

