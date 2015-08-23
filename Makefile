FSLEX := $(wildcard FsLexYacc.*/build/fslex.exe)
FSYACC := $(wildcard FsLexYacc.*/build/fsyacc.exe)
FSLEXYACCRUNTIMEPATH := $(wildcard FsLexYacc.Runtime.*/lib/net40)
FSLEXYACCRUNTIME := $(FSLEXYACCRUNTIMEPATH)/FsLexYacc.Runtime.dll

FSC := fsharpc
FSI := fsharpi
FSLEX := mono $(FSLEX)
FSYACC := mono $(FSYACC)
RM := rm -rf

OUTPUTS = Lexer.fs Parser.fs Program.exe

build: $(OUTPUTS)

Lexer.fs: Lexer.fsl
	$(FSLEX) --unicode $<

Parser.fs: Parser.fsy
	$(FSYACC) --module $(basename $<) $<

Program.exe: Parser.fs Lexer.fs Program.fs
	$(FSC) -r $(FSLEXYACCRUNTIME) $^ -o:$@

FsLexYacc.Runtime.dll: $(FSLEXYACCRUNTIME)
	cp $(FSLEXYACCRUNTIME) $(notdir $<)

run: Program.exe FsLexYacc.Runtime.dll
	mono $<

get-fslexyacc:
	nuget install FsLexYacc 

.PHONY:
clean:
	$(RM) $(OUTPUTS) *~
