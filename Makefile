CFLAGS = -msse2 --std gnu99 -O0 -Wall
EXEC = native_transpose sse_transpose sse_prefetch_transpose
SRCS_common = main.c
C_INCLUDE = impl.c

all: $(EXEC)

native_transpose: $(SRCS_common) $(C_INCLUDE)
	$(CC) $(CFLAGS) -DNATIVE -o $@ $(SRCS_common)

sse_transpose: $(SRCS_common) $(C_INCLUDE)
	$(CC) $(CFLAGS) -DSSE -o $@ $(SRCS_common)

sse_prefetch_transpose: $(SRCS_common) $(C_INCLUDE)
	$(CC) $(CFLAGS) -DSSE_PREF -o $@ $(SRCS_common)

run:
	echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
	perf stat -e cache-misses,cache-references,instructions,cycles ./native_transpose
	echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
	perf stat -e cache-misses,cache-references,instructions,cycles ./sse_transpose
	echo "echo 1 > /proc/sys/vm/drop_caches" | sudo sh
	perf stat -e cache-misses,cache-references,instructions,cycles ./sse_prefetch_transpose

astyle:
	astyle --style=kr --indent=spaces=4 --indent-switches --suffix=none *.[ch]

clean:
	$(RM) $(EXEC)
