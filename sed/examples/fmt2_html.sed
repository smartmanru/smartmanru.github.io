#!/bin/sed -rnf

# �������������� HTML, ��� ���� ����������
# ������ � ���� ������

# �������� ������ ������...
# �������� ������� ��������
s/^\s+//
/^</{
	# ������ ������ ���������� � ����
	# ������� ���������, �� ��������-�� ��� ������������
	/^<!--/{
		:comment
		# ��� ������ ���������� � ����������
		# ���������� � �������, � ��������� ����� �ӣ, ����� -->
			/-->/{
				# ������ ���-�� �������� ���������� ��������
				# ������� ���
				:remove_substring
					s//&\n/
					P
					D
			}
			# ������ �� �������� ����� ��������, ������ ����.
			# ��������� ������ ������: �������ۣ���� �������
			$ b error
			N
			s/\r?\n/<\\n>/
			b comment
	}
	t javascript_start
	:javascript_start
	s/^<script\s+language=(["']?)JavaScript\1>/\L&/i
	t javascript
	s~^<script\s+type=(["']?)text/javascript\1>~\L&~i
	T css_start
		# ��� ������ �����������
		:javascript
			\~</script>~I b remove_substring
			$ b error
			n
			s/^/<script language="JavaScript">/
			b javascript
	:css_start
	s~^<style\s+type=(["']?)text/css\1>~\L&~i
	T tag
		:css
			\~</style>~I b remove_substring
			$ b error
			n
			s~^~<style type="text/css">~
			b css
	:tag
		/>/{
			s/^[^>]*>/\L&\n/
			P
			D
		}
		# ������ �������� �� ����� ���
		$ b error
		N
		s/\r?\n/ /
		b tag
}

/</{
	# ������ �� ���������� � ����, ��, ������, ��� ��������
	s/\s*</\n</
	P
	D
}

# ��������� ������� ������� > ��� �����
/>/ b error

s/\s+$//
# ���������, �� ��������-�� ������ ������, � �������� ţ
/^$/! p
b

:error
	s/.*/\x1b[31;1mErorr in line '&'\x1b[0m/p
	q 77			
