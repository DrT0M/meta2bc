.syntax Hello_C

print	:	'printf(' 
			.string		{`i $ ' 1 prints' `n}
		');'
	|	'putchar('
			.number		{`i # ' 1 putc' `n}
		');'
	;

Hello_C	:	'main()'			{`i 'def main' `n}
		'{'				{`i '{' `n}
						{`>}
			*print
			'return;'		{`i 'return0' `n}
						{`<}
		'}'				{`i '}' `n}
	;

.end
