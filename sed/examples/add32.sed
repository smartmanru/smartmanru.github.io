#!/bin/sed -rnf

# ���� ������ ��������� ����� � ����� �� 32 �����
# � ������ ������ ���������� ��� ������, � ������ - ������ ������

1 {
	h
	N
	s/(.*)\n(.*)/tar -cpvf "\1" "\2"/ep
	b
}

2~32 b add
$ b add

H
b

:add
H
g
s/\n/" "/g
s/.*/tar -rpvf "&" || echo "ERROR"/ep
/ERROR/ q 77
x
s/\n.*//
x
b
