#!/bin/sed -rnf

s/<div class[^>]+>/ /g
s/<!--[^>]*-->/ /g
s~<span style="color:(#[[:xdigit:]]{6}|(dark)?(red|blue|green|Orchid|Sienna))">~ ~ig
s~</?(b|i|u|s|blockquote|div align=['"]center['"]|div|span)>~ ~ig
s/^\s*������� �������:.*//
s/\s+/ /g
s/^ //
s/ $//

/^$/d
/^TOP [0-9]+$/{
	p
	b
}

s/^/~/
t l3

:l3
s/^~���������� � ������$//
t

s/^~��������: (.*)/NMR \1/
t exit
s/^~������������ ��������: (.*)/NMO \1/
t exit
s/^~��� (������|�������): ([0-9]{4})$/YER \2/
t exit
s/^~��� ������:$//
t
s/^~����: (.*)/GNR \1/
t exit
s/^~��������: (.*)/DIR \1/i
t exit
s/^~� �����: (.*)/ACT \1/i
t exit
s/^~(����������|� ������):$/DIS/i
t exit
s/^~(���������[��]:|� ������:)\s+/DIS\n~/i
t exit
s/^~���������� � ��������/DIS\n&/i
t exit
s/^~����� � ������������ ��������.$/DIS\n&/i
t exit

#IMDB
\%http://(www\.)?imdb\.com/%I{
	# �������� ��������
	s/<img src="[^"]+"[^>]*>//i
	t li1
	:li1
	#<a href="http://www.imdb.com/title/tt0078767/" target="_blank"></a> 5.8/10 9,588 votes
	# �������� ������
	s%^~<a href="(http://(www\.)?imdb\.com/[^"]+)"[^>]*>\s*%IMD "\1"\n%i
	T err
	h
	#IMDB </a> 4.7/10 (1,871 votes)
	#IMDB</a> 6.9 /10 (1,771 votes)
	#IMDB</a> 8.2/10 (1,543 votes)
	#</a>5.8/10 9,588 votes
	s~^.*\n(imdb)?\s*</a>\s*([0-9.]+)\s*/10\s+\(?([0-9,]+)\s+votes\)?( / Top 250: \#[0-9]+)?$~\2 \3~i
	t li2
	#</a> 6.4/10
	s~^.*\n\s*</a>\s*([0-9.]+)\s*/10~\1~i
	t li2
	#User Rating: 6.2/10 (271 votes) </a>
	s~^.*\n(User Rating: )([0-9.]+)/10 \(([0-9,]+) votes\)\s*</a>$~\2 \3~i
	t li2
	# IMDb </a> / <a href="http://www.kinopoisk.ru/level/1/film/1762/" target="_blank"> ��������� </a>
	s~^(.*\n)imdb\s*</a>\s*/\s*<a href="([^"]+)"[^>]*>\s*���������\s*</a>$~\1KNP "\2"~i
	t exit
	b err
	:li2
		s/,//g
		H
		x
		s/\n.*\n/ /
	b exit		
}
#IMDB Rating: 8.2/10 (2,549 votes)
s%^~IMDB (rating: )?([0-9.]+)\s*/\s*10 \(([0-9,]+) votes\)$%IMD "" \1 \2%i
T li3
	s/,//
	b exit
:li3


:l12
s/^~��������: (.*)/MKE \1/
t exit
s/^~�����������������:\s*([0-9]{1,2}:[0-9]{2}:[0-9]{2})(\s*\+\s*(\s[0-9]{2}:[0-9]{2}:[0-9]{2})(\s.*)?)?$/TML \1\3/i
t exit
#~�����������������: 3 � 13 ��� 03 ���
s/^~�����������������: ([0-9]{1,2}) � ([0-9]{2}) ��� ([0-9]{2}) ���$/TML \1:\2:\3/i
s/^~(�����������|�������|����):\s+(.*)/LNG \2/
t exit
s/^~����$//
t
s/^~������: (.*)/FMT \1/
t exit
s/^~��������: (.*)/QUL \1/
t exit
s/^~�����: (.*)/VID \1/
t exit
s/^~(�����|����): (.*)/AUD \2/i
t exit
s/^~���� #[123]: (.*)/AUD \1/
t exit
s/^~������:? //i
t
s/^~�������: �����$//
t
s/^~�������������� ����������: //i
t
s/^~���$//i
t
s%^~�������: <a href="([^"]+)"[^>]*>\s*�����\s*</a>\s*%SMP \1\n%i
T lx1
	s/\n$//
	t exit
	s%\n/\s*<a href="([^"]+)"[^>]*>��������</a>$%\nSUB \1%i
	t exit
	b err
:lx1
s%~(����� ������|����� ��):?\s*<img src="([^"]+)"[^>]*>$%REL \2%i
t exit
s%~����� ������$%%i
t


# ����������� ������
#s/.*/'\x1b[31;1m&\x1b[0m'/p
p
b

:exit
	#s/^.../\x1b[32m&\x1b[0m/mg
	p
	b

:err
	s/.*/\x1b[31;1mError - '&'\x1b[0m/p
	q 74

