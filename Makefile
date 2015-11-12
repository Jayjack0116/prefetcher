CFLAGS = -msse2 --std gnu99 -O0 -Wall
TARGET = main
all: $(TARGET)

$(TARGET): main.c
	$(CC) $(CFLAGS) $< -o $@ 

run:
	echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
	perf stat -e cache-misses,cache-references,instructions,cycles ./main

astyle:
	astyle --style=kr --indent=spaces=4 --indent-switches --suffix=none *.[ch]

clean:
	$(RM) $(TARGET)
