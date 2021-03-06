        ��  ��                  %  <   T E X T F I L E   D E F _ D T D         0         <!ELEMENT program (types?, vars?, consts?, comments?, subroutines?, block*)>

<!ATTLIST program 
	lang    (0|1|2) #IMPLIED
        name    CDATA   #IMPLIED>

<!ELEMENT vars (var*)>
<!ELEMENT var (#PCDATA)>
<!ATTLIST var
	type CDATA	#REQUIRED
	size CDATA	#REQUIRED>

<!ELEMENT consts (const*)>
<!ELEMENT const (#PCDATA)>
<!ATTLIST const
	name	CDATA	#REQUIRED>

<!ELEMENT comments (comment*)>
<!ELEMENT comment (#PCDATA)>
<!ATTLIST comment
	x	CDATA	#REQUIRED
	y	CDATA	#REQUIRED
	w	CDATA	#REQUIRED
	h	CDATA	#REQUIRED
        fontsize (8|10|12)  #IMPLIED>

<!ELEMENT types (type*)>
<!ELEMENT type (field*)>
<!ATTLIST type
	name CDATA	#REQUIRED
	pointer (true|false|True|False|TRUE|FALSE) #IMPLIED
	ext_decl (true|false|True|False|TRUE|FALSE) #IMPLIED
	library CDATA	#IMPLIED>


<!ELEMENT field EMPTY>
<!ATTLIST field
	name CDATA	#REQUIRED
	type CDATA	#REQUIRED
	table (true|false|True|False|TRUE|FALSE)	#IMPLIED>

<!ELEMENT subroutines (subroutine*)>
<!ELEMENT subroutine (arg*)>
<!ATTLIST subroutine
	name CDATA	#REQUIRED
	type CDATA	#REQUIRED
	ext_decl (true|false|True|False|TRUE|FALSE) #IMPLIED 
	library CDATA	#IMPLIED>

<!ELEMENT arg EMPTY>
<!ATTLIST arg
	name CDATA	#REQUIRED
	type CDATA	#REQUIRED
	table (true|false|True|False|TRUE|FALSE)	#IMPLIED
	reference (true|false|True|False|TRUE|FALSE)	#IMPLIED>

<!ELEMENT block (text?,foldtext?,branch*,i_var?,init_val?,end_val?)>
<!ATTLIST block
	x	CDATA	#REQUIRED
	y	CDATA	#REQUIRED
	h	CDATA	#REQUIRED
	w	CDATA	#REQUIRED
	brx	CDATA	#REQUIRED
	bh	CDATA	#REQUIRED
	type	(begin-end|while-do|assign|mult-assign|for-do|if-else|if|case|input|output|repeat-until|subroutine)	#REQUIRED
	folded	(true|false|True|False|TRUE|FALSE)	#IMPLIED 
	fbrx	CDATA	#IMPLIED
	th	CDATA	#IMPLIED
	bry	CDATA	#IMPLIED
	fbry	CDATA	#IMPLIED
	flh	CDATA	#IMPLIED
	trh	CDATA	#IMPLIED
	fontsize	(8|10|12)	#IMPLIED>

<!ELEMENT text (#PCDATA)>
<!ELEMENT i_var (#PCDATA)>
<!ELEMENT init_val (#PCDATA)>
<!ELEMENT end_val (#PCDATA)>
<!ELEMENT x (#PCDATA)>
<!ELEMENT y (#PCDATA)>
<!ELEMENT foldtext (#PCDATA)>
<!ELEMENT branch (x,y,block*,value?)>
<!ELEMENT value (#PCDATA)>
   