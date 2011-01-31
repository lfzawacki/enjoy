enjoy
---------
Enjoy interfacing your joystick with your OS!

## Objective

This software is written as a simple way of letting you use joystick devices to perform various tasks
in your computer. Run macro commands, open many softwares at once, send key events and much more.

I'm trying to experiment here with an easily extendable text configuration format. It uses the Lua
language and strives to be rapidly readable and writable by humans!

## Compatibility

Right now it only works under Linux, because that's where I'm using it. I swear I'll try hard to get
Windows, Mac and other *nixes, cuz I want people to use this (if they find it usefull).

## Running

This is an evil dev release as of now... you have to type `make` to compile and then `./enjoy` to run.

It will recognize `/dev/input/js0` as default, but another one can be passed as a parameter at startup:

    ./enjoy /dev/input/js1 #or maybe some other esoteric device path

## Writing your own mapping files

Here's an excerpt of a mapping file, it controls a music playing software (complete example is available in the mapping/exaile.lua file).

	button '1'
		explain 'Next track'
		cmd 'exaile -n'

	button '0'
		explain 'Volume++'
		cmd 'exaile -i 10'

	button '4'
		explain 'Play/Pause'
		cmd 'exaile --play-pause'

	button '8'
		explain 'Reload and show instructions'
		load 'self'

Many important things here. To start the mapping you need to use the button directive followed by the button number. After that you can proceed to fill this button with the actions you want to execute every time it's pressed.

### Availabe commands

> Notice that every text command that goes into the configuration file is enclosed with "" or ''. There's a good reason, explained elsewhere, for this.

* **button**: Sets the given button as the current one receiving commands

* **cmd**: Can be given a command to be executed in the operating system shell

* **toggle**: Similar to `cmd`, but should be used whit two commands as toggle switch.

* **explain**: Here you may write explanation of what this button is doing

* **load**: Can be used to change the set of commands being used, just give it the name of the new file. If it's given 'self' it reloads the file instead. By default files are looked up in the `mapping` directory (and that can't be changed in a pretty way for now)

* **notify**: Can be given a message to be shown graphically.

## Custom extensions

The 'syntax' for the mapping files is just plain Lua code and be extended in an easy manner, as can be seem
the mapping/hydrogen.lua and mapping/drum.lua files.

# Future Versions

I intend to implement this in the future, if I have the motivation

* Proper API documentation for the Lua geeks :B and another one for normal people
* True support for sending key events (that works transparently in all platforms)
* True support for notifications (even though portability is hard here)
* Run a command if a button is held
* Run commands with button combinations (1+2 for example)
* Support for joystick axis mapping
* A nice GUI to query the button IDs and make crafting the mapping files easier

