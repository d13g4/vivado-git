################################################################################
#
# This file provides a basic wrapper to use git directly from the tcl console in
# Vivado.
# It requires the write_project_tcl_git.tcl script to work properly.
# Unversioned files will be put in the work/ folder
#
# Ricardo Barbedo
#
################################################################################

namespace eval ::git_wrapper {
    namespace export git
    namespace import ::custom::write_project_tcl_git
    namespace import ::current_project
    namespace import ::common::get_property

    proc git {args} {
        set command [lindex $args 0]

        # Change directory project directory if not in it yet
#        set proj_dir [regsub {\/work$} [get_property DIRECTORY [current_project]] {}]
        set proj_dir [get_property DIRECTORY [current_project]]
        set current_dir [pwd]
        if {
            [string compare -nocase $proj_dir $current_dir]
        } then {
            puts "Not in project directory"
            puts "Changing directory to: ${proj_dir}"
            cd $proj_dir
        }

        switch $command {
            "init" {git_init {*}$args}
            "commit" {git_commit {*}$args}
            "default" {exec git {*}$args}
        }
    }

    proc git_init {args} {
        # Generate gitignore file
        set file [open ".gitignore" "w"]
        puts $file [current_project].cache
        puts $file [current_project].hw
        puts $file [current_project].ip_user_files
        puts $file [current_project].runs
        puts $file [current_project].sim
        puts $file [current_project].xpr
        puts $file *.log
		puts $file *.jou
		close $file

        # Initialize the repo
        exec git {*}$args
        exec git add .gitignore
    }

    proc git_commit {args} {
        # Get project name

	if {
	    [string compare -nocase $args "commit"] == 0
	} then {
	    puts "git commit requires -m flag, aborted"
	    return
	}

        set proj_file [current_project].tcl

        # Generate project and add it
        write_project_tcl_git -no_copy_sources -force $proj_file
        puts $proj_file
        exec git add $proj_file

        # Now commit everything
        exec git {*}$args
    }
}
