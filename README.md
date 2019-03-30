# meta2bc
Extended META II Bootstrap Compiler Compiler


This META II Bootstrap Compiler Compiler (meta2bc)
translates an extended META II syntax specification (*.m2)
into compiler logic in BC code (*1.bc), and
string defs in another segment (*0.bc).

This code release consists of:
meta2bc.m2  - extended META II to BC syntax (this file)
meta2bc0.bc - extended META II string defs
meta2bc1.bc - extended META II logic
meta2hdr.bc - header code for translator

The BC code modules (*.bc) can be compiled with BCC (bootstrapped compiler compiler):
https://web.archive.org/web/20160528210445fw_/http://homepage.ntlworld.com/edmund.grimley-evans/bcompiler.tar.gz
Follow EdGE's instructions to bootstrap your BCC.  You need to keep header.bc and the binary executable bcc.

Compile meta2bc:
%	cat header.bc meta2hdr.bc meta2bc0.bc meta2bc1.bc | ./bcc > ./meta2bc && chmod +x ./meta2bc




Hello World example (obligatory)

Compile c2bc - C to BC syntax directed translator:
%	(./meta2bc < c2bc.m2 > c2bc1.bc) >& c2bc0.bc
%	cat header.bc meta2hdr.bc c2bc0.bc c2bc1.bc | ./bcc > ./c2bc && chmod +x ./c2bc

Translate hello.c to hello*.bc:
%	(./c2bc < hello.c > hello1.bc) >& hello0.bc

Compile hello*.bc to hello binary and execute:
%	cat header.bc hello0.bc hello1.bc | ./bcc > ./hello && chmod +x ./hello && ./hello




Writing binary image example

In addition to translating input code to output code (text),
this extended META II Bootstrap Compiler Compiler has
translation directives to write binary output.

Compile num2exit - a binary executable generator:
%	(./meta2bc < num2exit.m2 > num2exit1.bc ) >& num2exit0.bc
%	cat header.bc meta2hdr.bc num2exit0.bc num2exit1.bc | ./bcc > num2exit && chmod +x num2exit

Generate binary executable (with ELF header) that sets the exit code to the input number:
%	echo 42 | ./num2exit > exit42 && chmod +x exit42 && ./exit42
%	echo $?

Compile hex2exit - another binary executable generator:
%	(./meta2bc < hex2exit.m2 > hex2exit1.bc ) >& hex2exit0.bc
%	cat header.bc meta2hdr.bc hex2exit0.bc hex2exit1.bc | ./bcc > hex2exit && chmod +x hex2exit

Generate binary executable (with ELF header) that sets the exit code to the input hex:
%	echo \`2a | ./hex2exit > hexit42 && chmod +x hexit42 && ./hexit42
%	echo $?




Self Hosting - meta2bc compiles itself

Compile extended META II syntax specification to BC code by redirecting 
global definitions to stderr (check here for any error), and
the compiler logic to stdout:
%	(./meta2bc < meta2bc.m2 > new_meta2bc1.bc) >& new_meta2bc0.bc

Confirm self hosting using diff and wc (should give 0 for same specs ):
%	diff new_meta2bc0.bc meta2bc0.bc | wc
%	diff new_meta2bc1.bc meta2bc1.bc | wc

Compile the next generation Extended META II Bootstrap Compiler Compiler:
%	cat header.bc meta2hdr.bc new_meta2bc0.bc new_meta2bc1.bc | ./bcc > ./new_meta2bc && chmod +x ./new_meta2bc

Confirm self hosting using diff and wc (should give 0 for same specs):
%	diff new_meta2bc meta2bc | wc




References

D. V. Schorre
META II: A Syntax-Oriented Compiler Writing Language
Proceedings of the 19th ACM National Conference (1964), ACM Press, New York, NY
http://www.chilton-computing.org.uk/acl/literature/reports/p025.htm

James M. Neighbors
Tutorial: Metacompilers Part 1
2008, Revised 2016
http://www.bayfronttechnologies.com/mc_tutorial.html
