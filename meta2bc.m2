! DrT0M © 2019	! MIT License

.syntax meta2	! Extended META II Bootstrap Compiler Compiler

meta2
	:	'.syntax'		{`i 'def main' `n}
					{`i '{' `n}
		{`>}			{`i 	'initialize' `n}
					{`i 	'133 COMMENT1= # syntax comment starts (left bracket)' `n}
					{`i 	'135 COMMENT0= # syntax comment stops (right bracket)' `n}
					{`i 	'33 comment1= # syntax alt comment starts (exclamation)' `n}
					{`i 	'10 comment0= # syntax alt comment stops (end of line)' `n}
					{`i 	'39 quote1= # syntax quote for strings (single quote)' `n}
					{`i 	'34 quote2= # syntax quote-alternative (double quote)' `n}
					{`i 	'96 quote0= # syntax quote for hexbyte (backtick)' `n}
		.id			{`i 	'syntax_rule_' $ `n}
					{`i 	'return0' `n}
		{`<}			{`i '}' `n}
					{`i 'def indentation { 9 putchar return0 } # tab' `n}
					{`i '# def indentation { 32 putchar 32 putchar return0 } # 2 spaces' `n}
		*statement
		'.end'
	;

statement
	:	.id			{`i 'def syntax_rule_' $ `n}
					{`i '{' `n}
		{`>}
		':' alternative ';'	{`i 	'return0' `n}
		{`<}			{`i '}' `n}
	;

alternative
	:	sequence
		*(	'|'		{`i 'matched not if # above alternative' `n}
		{`>}
			   sequence
		{`<}			{`i 'fi' `n}
		 )
	;

sequence
	:	(	primary_exp	{`i 'matched if # primary_exp first in sequence' `n}
		 |	translation	{`i       '1 if # translation first in sequence' `n}
		)
		{`>}
			*( primary_exp	{`i 'matched require # for primary_exp next in sequence' `n}
			  |translation
			 )
		{`<}			{`i 'fi' `n}
	;

primary_exp
	:	.id			{`i 'syntax_rule_' $ `n}
	|	.string			{`i $ ' test_literal' `n}
	|	'.id'			{`i 'read_token_id' `n}
	|	'.hex'			{`i 'read_token_hex' `n}
	|	'.number'		{`i 'read_token_dig' `n}
	|	'.string'		{`i 'read_token_str' `n}
	|	'.empty'		{`i '1 matched=' `n}
	|	'.e'			{`i '1 matched=' `n}
	|	precedence
	|	repetition
	;

repetition
	:	'*'			{`i '{ # repetition' `n}
		{`>}
			primary_exp	{`i 'matched while' `n}
					{`i 'continue' `n}
		{`<}			{`i '} 1 matched=' `n}
	;

precedence
	:	'(' 			{`i '# ( precedence' `n}
		alternative 
		')'			{`i '# ) precedence' `n}
	;

translation
	:	'{' *directive '}'
	;

directive
	:	.string			{`i $ ' emit' `n}
	|	.number			{`i # ' putchar' `n}
	|	.hex			{`i % ' putchar' `n}
	|	'$'			{`i 'last_token emit' `n}
	|	'#'			{`i 'last_token dig2num 1 printd' `n}
	|	'%'			{`i 'last_token hex2num 1 printd' `n}
	|	'?$'			{`i 'stack_peek emit' `n}
	|	'?#'			{`i 'stack_peek dig2num 1 printd' `n}
	|	'?%'			{`i 'stack_peek hex2num 1 printd' `n}
	|	'`$'			{`i 'stack_pop emit' `n} 
	|	'`#'			{`i 'stack_pop dig2num 1 printd' `n} 
	|	'`%'			{`i 'stack_pop hex2num 1 printd' `n} 
	|	'`^'			{`i 'last_token stack_push' `n}
	|	'`~'			{`i 'stack_swap' `n}
	|	'`N'			{`i '13 putchar 10 putchar' `n}	! dos cr lf
	|	'`r'			{`i '13 putchar' `n}		! mac carriage return
	|	'`n'			{`i '10 putchar' `n}		! unix line feed
	|	'`t'			{`i  '9 putchar' `n}		! tab
	|	'`q'			{`i '39 putchar' `n}		! single quote
	|	'`Q'			{`i '34 putchar' `n}		! double quote
	|	'`I'			{`i 'indent_reset' `n}
	|	'`>'			{`i 'indent_incr' `n}
	|	'`<'			{`i 'indent_decr' `n}
	|	'`i'			{`i 'indent_emit' `n}
	;

license	:	"Copyright © 2019 DrT0M"
		""
		"Permission is hereby granted, free of charge, to any person"
		"obtaining a copy of this software and associated documentation"
		"files (the 'Software'), to deal in the Software without"
		"restriction, including without limitation the rights to use,"
		"copy, modify, merge, publish, distribute, sublicense, and/or"
		"sell copies of the Software, and to permit persons to whom the"
		"Software is furnished to do so, subject to the following"
		"conditions:"
		""
		"The above copyright notice and this permission notice shall be"
		"included in all copies or substantial portions of the Software."
		""
		"THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,"
		"EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES"
		"OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND"
		"NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT"
		"HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,"
		"WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING"
		"FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR"
		"OTHER DEALINGS IN THE SOFTWARE."
	;

.end

[README


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




(tab stop @ 8)
(comments enclosed between brackets)]
