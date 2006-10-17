NEKO_MODULES=xinf/ul/Test xinf/euclid/Test 
RUN=xinf/$(TEST)/Test
include project.make

SUBDIRS = libs

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

#default : subdirs

JS_MODULES=xinf/erno/Test

cleanall : clean
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
        
%.run : %.n %.hx
	NEKOPATH=$(NEKOPATH) neko $*

erno: xinf/erno/Test.run 
ony: xinf/ony/Test.run
ul: xinf/ul/Test.run
inity: xinf/inity/Test.run
gst: xinf/inity/gst/Test.run

fonts: demo/inity/FontView.run

euclid: xinf/euclid/Test.run
live: xinf/live/Test.run

