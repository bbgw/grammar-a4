.DEFAULT_GOAL := py

all : py ja _compile
.PHONY: prepy py ja all

antlr4 := java -Xmx500M -cp "/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH" org.antlr.v4.Tool
grun := java -Xmx500M -cp "/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig

filedir := ./antlr/antlr4/
out_java := ./java
out_python := ./py

options := -visitor

prepy:
	mkdir -p $(out_python)
	test -f $(out_python)/LexBasic.g4 || ln -s ../$(filedir)/LexBasic.g4 $(out_python)/.
	test -f $(out_python)/ANTLRv4Parser.g4 || ln -s ../$(filedir)/ANTLRv4Parser.g4 $(out_python)/.
	test -f $(out_python)/ANTLRv4Lexer.g4 || ln -s ../$(filedir)/Python3/ANTLRv4Lexer.g4 $(out_python)/.
	test -f $(out_python)/LexerAdaptor.py || ln -s ../$(filedir)/Python3/LexerAdaptor.py $(out_python)/.

prepj:
	mkdir -p $(out_java)
	test -f $(out_java)/LexBasic.g4 || ln -s ../$(filedir)/LexBasic.g4 $(out_java)/.
	test -f $(out_java)/ANTLRv4Parser.g4 || ln -s ../$(filedir)/ANTLRv4Parser.g4 $(out_java)/.
	test -f $(out_java)/ANTLRv4Lexer.g4 || ln -s ../$(filedir)/ANTLRv4Lexer.g4 $(out_java)/.
	test -f $(out_java)/LexerAdaptor.java || ln -s ../$(filedir)/Java/LexerAdaptor.java $(out_java)/.

py: prepy
	@echo ">>>"
	$(antlr4) $(options) -Dlanguage=Python3 $(out_python)/ANTLRv4Parser.g4 $(out_python)/ANTLRv4Lexer.g4
	@echo "<<<"

# s.t. being able to use TestRig
ja: prepj
	@echo ">>>"
	$(antlr4) $(options) -Dlanguage=Java $(out_java)/ANTLRv4Parser.g4 $(out_java)/ANTLRv4Lexer.g4
	@echo "<<<"

_compile: ja
	javac -cp "/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH" $(out_java)/*.java

clean:
	@echo "Cleaning up builds"
	rm $(out_python)/*.interp		\
	   $(out_python)/*.tokens		\
	   $(out_python)/ANTLRv4*.py	\
	   $(out_java)/*.interp			\
	   $(out_java)/*.tokens			\
	   $(out_java)/ANTLRv4*.java 	\
	   $(out_java)/*.class
	@echo "Done"
