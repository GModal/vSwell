
all: hvcc plugins

PLUGIN = vSwell vSwellST

DEST_LV2 = .lv2
DEST_VST = .vst
DEST_CLAP = .clap
HM = ~/

plugins: hvcc
	$(foreach var, $(PLUGIN), make -C $(var)/ features;)
	$(foreach var, $(PLUGIN), make -C $(var)/ $(MAKECMDGOALS);)

hvcc:
	$(foreach var, $(PLUGIN), hvcc $(var).pd -n $(var) -m $(var).json -o $(var) -g dpf -p ./ ../heavylib;)

binmove:
	mkdir bin
	$(foreach var, $(PLUGIN), mv $(var)/bin/* bin/;)

install:
	$(foreach var, $(PLUGIN), rm -rf $(HM)$(DEST_LV2)/$(var).lv2 ;)
	$(foreach var, $(PLUGIN), cp -r $(var)/bin/$(var).lv2 $(HM)$(DEST_LV2)/ ;)	
	$(foreach var, $(PLUGIN), rm -rf $(HM)$(DEST_VST)/$(var)-vst.so ;)
	$(foreach var, $(PLUGIN), cp -r $(var)/bin/$(var)-vst.so $(HM)$(DEST_VST)/ ;)		
	$(foreach var, $(PLUGIN), rm -rf $(HM)$(DEST_CLAP)/$(var).clap ;)
	$(foreach var, $(PLUGIN), cp -r $(var)/bin/$(var).clap $(HM)$(DEST_CLAP)/ ;)
	
modduo: all
modduox: all
moddwarf: all
