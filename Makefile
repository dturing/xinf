NEKO_MODULES=xinf/x11/XinfTest
RUN=xinf/x11/XinfTest

include project.make

SUBDIRS = libs test

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@


default : subdirs

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
            
