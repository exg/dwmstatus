#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <X11/Xlib.h>

static char *
get_datetime(char *fmt)
{
	char buf[128];
	time_t now;
	struct tm *tm;

	now = time(NULL);
	tm = localtime(&now);
	if (tm == NULL)
		return strdup("");

	if (!strftime(buf, sizeof(buf), fmt, tm))
		return strdup("");

	return strdup(buf);
}

static char *
get_load(void)
{
	double avgs[3];

	if (getloadavg(avgs, 3) < 0)
		return strdup("");

	char *ret;
	asprintf(&ret, "%.2f %.2f %.2f", avgs[0], avgs[1], avgs[2]);
	return ret;
}

int
main(void)
{
	Display *dpy = XOpenDisplay(NULL);
	if (!dpy) {
		fprintf(stderr, "dwmstatus: cannot open display.\n");
		return 1;
	}

	for (;;sleep(60)) {
		char *load = get_load();
		char *datetime = get_datetime("%a %Y-%m-%d %H:%M");
		char *status;
		asprintf(&status, "L:%s %s", load, datetime);
		XStoreName(dpy, DefaultRootWindow(dpy), status);
		XSync(dpy, False);
		free(load);
		free(datetime);
		free(status);
	}

	XCloseDisplay(dpy);

	return 0;
}
