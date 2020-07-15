#!/bin/sh
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

printf '\nProject name: '; IFS= read -r project_name
printf 'Your name: '; IFS= read -r person_name
printf 'Your SID: '; IFS= read -r person_sid

if [ -z "$project_name" ]
then
	printf '\nProject Name Needed!\n';
	sleep 1
	exit
fi

mkdir -p "$project_name"/source
mkdir -p "$project_name"/results
mkdir -p "$project_name"/submodules
mkdir -p "$project_name"/turnin
mkdir -p "$project_name"/testbench

project_name_tb="$project_name"_tb
cat > "$project_name"/testbench/"$project_name"_tb.v << EOF
\`timescale 1ns/1ps
module $project_name_tb;






	initial begin
		\$dumpfile(\`DUMP_FILE_NAME);
		\$dumpvars(0, $project_name_tb);
	end
endmodule

EOF

printf 'Name: %s\nSid: %s\n' "$person_name" "$person_sid" > "$project_name"/README.md

cat "$DIR"/goboard_Makefile_template >> "$project_name"/Makefile
cat "$DIR"/Go_Board_Constraints.pcf >> "$project_name"/"$project_name"_constraints_top.pcf

