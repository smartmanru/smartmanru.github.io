#!/bin/sed -rf

:begin
$!{
	N
	b begin
}

s/[	]/���������/g
s/[\n]/������� ������/g
