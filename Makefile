all:
	$(CC) -o enjoy enjoy.c -llua -lm  -ldl

# not used for now
send_key.o: key_event_x11.c
	$(CC) -c -o $@ $^ -lX11 -lXtst

