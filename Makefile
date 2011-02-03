all:
	$(CC) -o enjoy enjoy.c -llua -lm -lSDL -ldl -g

check:
	@echo "Lot's of these global assigns are 'by design'..."
	@echo "I plan to remove them :)"
	lua lualint/lualint core.lua

# not used for now
send_key.o: key_event_x11.c
	$(CC) -c -o $@ $^ -lX11 -lXtst

