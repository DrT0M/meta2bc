.syntax set_exit_code

set_exit_code
	:	.number	
		{
			127  069  076  070  001  001  001  000  000  000
			000  000  000  000  000  000  002  000  003  000
			001  000  000  000  084 -128  004  008  052  000
			000  000  000  000  000  000  000  000  000  000
			052  000  032  000  001  000  000  000  000  000
			000  000  001  000  000  000  000  000  000  000
			000 -128  004  008  000 -128  004  008  -65  000
			000  000  -65  000  000  000  005  000  000  000
			000  016  000  000  049  -64  064  -77
			$
			-51 -128
		}
	; 

.end

[
(./meta2bc < num2exit.m2 > num2exit1.bc ) >& num2exit0.bc
cat header.bc meta2hdr.bc num2exit0.bc num2exit1.bc | ./bcc > num2exit && chmod +x num2exit
echo 42 | ./num2exit > exit42 && chmod +x exit42 && ./exit42
echo $?
42
]
