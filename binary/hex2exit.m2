.syntax set_exit_code

set_exit_code
	:	.hex
		{
			`7f `45 `4c `46 `01 `01 `01 `00 `00 `00 `00 `00 `00 `00 `00 `00
			`02 `00 `03 `00 `01 `00 `00 `00 `54 `80 `04 `08 `34 `00 `00 `00
			`00 `00 `00 `00 `00 `00 `00 `00 `34 `00 `20 `00 `01 `00 `00 `00
			`00 `00 `00 `00 `01 `00 `00 `00 `00 `00 `00 `00 `00 `80 `04 `08
			`00 `80 `04 `08 `bf `00 `00 `00 `bf `00 `00 `00 `05 `00 `00 `00
			`00 `10 `00 `00 `31 `c0 `40 `b3 
			$
			`cd `80
		}
	; 

.end

[
(./meta2bc < hex2exit.m2 > hex2exit1.bc ) >& hex2exit0.bc
cat header.bc meta2hdr.bc hex2exit0.bc hex2exit1.bc | ./bcc > hex2exit && chmod +x hex2exit
echo \`2a | ./hex2exit > hexit42 && chmod +x hexit42 && ./hexit42
echo $?
42
]
