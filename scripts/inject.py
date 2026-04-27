import sys

main_tex = sys.argv[1]
inputs_file = sys.argv[2]

with open(inputs_file) as f:
    inputs = f.read()

with open(main_tex) as f:
    lines = f.readlines()

out = []
for line in lines:
    if ">>> GENERATED_BY_MAKEFILE <<<" in line:
        out.append("% AUTO GENERATED\n")
        out.append(inputs)
    else:
        out.append(line)

with open(main_tex, "w") as f:
    f.writelines(out)