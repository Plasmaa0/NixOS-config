rofi_cmd() {
	rofi -dmenu \
		-p "   TODO notes   " \
		-mesg "TODO" \
		-theme ~/Documents/todo/style.rasi
}
edit="  Edit"
view="🖺 View"

run_rofi() {
	echo -e "${view}\n${edit}" | rofi_cmd
}

chosen=$(run_rofi)
case ${chosen} in
    "$edit")
    mkdir -p ~/Documents/todo
    kitty --class TODO -e hx ~/Documents/todo/todo.typ
    typst c ~/Documents/todo/todo.typ
    zathura ~/Documents/todo/todo.pdf
        ;;
    "$view")
    zathura ~/Documents/todo/todo.pdf
        ;;
esac

