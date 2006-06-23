NEKO_MODULES=xinf.x11.XinfTest

include make.settings

SUBDIRS = libs

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@


default : subdirs

bin/xtest.n : $(HAXE_SRCS) 
	haxe $(HAXEFLAGS) -neko bin/xtest.n -main xinf.x11.XinfTest 
xtest : subdirs bin/xtest.n 
	NEKOPATH=$(NEKOPATH):./libs:./gst:./bin neko bin/xtest.n 

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
            
