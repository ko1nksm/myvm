# myvm

My personal virtual machines for testing, and a build tool written in a simple and easy shell script.

**This is still a personal tool and at this time I do not intend to support it at this time. But you are free to use it if you wish.**

## What is this?

Tools for building virtual machines and my personal virtual machine environment building scripts. The goal is to automate to the installation of a basic operating system capable of ssh connections. The the virtual machine's keystroke function and OCR will be used as the technology for automated operations.

https://github.com/ko1nksm/myvm/assets/2453619/a8ff43de-271c-4d23-b073-99574b33a0d4

## Requirements

- `virsh` (libvirt)
- `virt-install` (virtinst)
- `tesseract` - OCR
- `gm` - GraphicsMagick
- VNC Viewer (recommendation)

## Usage

```txt
Usage: myvm run <shrc-file> [<tasks> | --step-on]...
Usage: myvm sendkey <shrc-file> [--ocr] [<keys>]...
Usage: myvm ocr <shrc-file>
Usage: myvm vnc <shrc-file> [enable | disable | display]
Usage: myvm demolish <shrc-file>
```

## DSL for building virtual machines

- `waitfor <regexp>` Wait for text to be output.
- `sendkey [string]...` Send Key corresponding to each character
- `enter [string]...` Enter a string. The end of the string contains a newline
- `repeat_sendkey <n> [string]...` Repeat the specified strings
- `timeout <seconds>` Extends the timeout for the next `waitfor`
- `step_on`  Turn on step execution for debugging

## Functions to manipulate virtual machines

- `vm.build` Create a virtual machine
- `vm.stop` Stop the virtual machine
- `vm.restart` Wait for the virtual machine to stop, then restart it
- `vm.setmem` Set virtual machine memory
- `vm.vnc` Enable or disable the VNC server for a virtual machine
- `vm.disk` Add a disk

## Configuration file

Load `~/.config/myvm` or `~/.myvm` if exists.

## Examples

```sh
# Create a virtual machine and run the build and setup tasks
$ ./myvm run debian/12.0.shrc build setup

# Demolish the created virtual machine
$ ./myvm demolish debian/12.0.shrc
```

See shrc files in the project.

Hint: You are free to define any function beginning with `do_` in the shrc file.