PREFIX ?= /usr
COMPLETIONS = share/bash-completion/completions
TARGETS = $(filter-out repo-x.bash, $(wildcard repo-*))

default:

install:
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 $(TARGETS) $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)$(PREFIX)/$(COMPLETIONS)
	install -m 644 repo-x.bash $(DESTDIR)$(PREFIX)/$(COMPLETIONS)
	for f in $(TARGETS); do ln -sf $(DESTDIR)$(PREFIX)/$(COMPLETIONS)/repo-x.bash $(DESTDIR)$(PREFIX)/$(COMPLETIONS)/$$f; done

uninstall:
	for f in $(TARGETS); do rm -f $(DESTDIR)$(PREFIX)/bin/$$f; done
	for f in $(TARGETS); do rm -f $(DESTDIR)$(PREFIX)/$(COMPLETIONS)/$$f; done
	rm -f $(DESTDIR)$(PREFIX)/$(COMPLETIONS)/repo-x.bash
