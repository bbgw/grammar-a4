.DEFAULT_GOAL := all

all : py ja _compile
.PHONY: py ja all

antlr4 := java -Xmx500M -cp "/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH" org.antlr.v4.Tool
grun := java -Xmx500M -cp "/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig

filedir := ./antlr/antlr4/
out_java := ./java
out_python := ./py

options := -visitor

py:
	@echo ">>>"
	$(antlr4) $(options) -Dlanguage=Python3 $(out_python)/ANTLRv4Parser.g4 $(out_python)/ANTLRv4Lexer.g4
	@echo "<<<"

# s.t. being able to use TestRig
ja:
	@echo ">>>"
	$(antlr4) $(options) -Dlanguage=Java $(out_java)/ANTLRv4Parser.g4 $(out_java)/ANTLRv4Lexer.g4
	@echo "<<<"

_compile: ja
	javac $(out_java)/*.java

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
