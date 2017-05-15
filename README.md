# vivado-git

Trying to make Vivado more git-friendly on Windows and Linux.

### Requirements for Windows

- [Git for Windows](https://git-scm.com/download/win)
- Add `C:\Program Files\Git\bin` (or wherever you have your `git.exe`) to your `PATH`

### Requirements for Linux

- Git for Linux

### Installation

Add `init.tcl` (or append the relevant lines if you already have something in it) along with the `scripts` directory to `%APPDATA%\Roaming\Xilinx\Vivado`.

### How it works

Vivado is a pain in the ass to source control decently, so these scripts provide:

  - A modified `write_project_tcl_git.tcl` script to generate the project script without absolute paths.
    (Original write_project_tcl.tcl is available at (https://github.com/Xilinx/XilinxTclStore/blob/master/tclapp/xilinx/projutils/write_project_tcl.tcl))

  - A git wrapper that will recreate the project script and add it before committing.

### Workflow

 1. After creating project in Vivado you have to make 'git init' under TCL console to add you project to Git. Git init wrapper automatically creates .gitignore file with all temporary folders and logs

 2. Here is an example of a possible project structure:
    ```
    PROJECT_NAME
        ├── .git
        ├── .gitignore
        ├── project_name.tcl         # Project generator script
        ├── project_name.srcs/       # Tracked source files
        │   ├── *.v
        │   ├── *.vhd
        │   └── ...
        ├── project_name.xpr         # Untracked generated files
        ├── project_name.cache/      # Untracked generated files
        ├── project_name.hw/         # Untracked generated files
        ├── project_name.sim/        # Untracked generated files
        └── ...
    ```

 3. Stage your source files with `git add`, for instance `git add project_name.srcs`

 4. When you are done, `git commit` your project. A `PROJECT_NAME.tcl` script will be created in your `C:/.../PROJECT_NAME` folder and added to your commit.

 5. All other Git commands (`git push`, `git branch`, etc) should work from TCL console as usual.

 6. When opening the project after a cloning, do it by using `Tools -> Run Tcl Script...` and selecting the `PROJECT_NAME.tcl` file created earlier. This will regenerate the project so that you can continue working.


TODO: Take care about SDK files (project_name.sdk/). Some of them are text but some others are binary.
