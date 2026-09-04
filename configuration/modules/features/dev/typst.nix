{...}: {
  flake.homeModules.dev-typst = {pkgs, ...}: {
    home.packages = with pkgs; [
      typst
      zathura
      (
        pkgs.writeShellApplication {
          name = "mdpdf";
          runtimeInputs = [
            pkgs.typst
            pkgs.zathura
            pkgs.coreutils
            pkgs.gnused
          ];
          text = ''
            set -eu

            if [ "$#" -ne 1 ]; then
              echo "usage: mdpdf <file.md>"
              exit 1
            fi

            input="$(readlink -f "$1")"
            base="$(basename "$input")"
            name="''${base%.*}"

            tmpdir="$(mktemp -d "/tmp/mdpdf-$name-XXXXXXXX")"
            md_file="$tmpdir/$base"
            typst_file="$tmpdir/$name.typ"
            pdf_file="$tmpdir/$name.pdf"

            cp "$input" "$md_file"

            sed -e 's/\\\[/$$/g' \
                -e 's/\\\]/$$/g' \
                -e 's/\\(/$/g' \
                -e 's/\\)/$/g' \
                "$md_file" > "$tmpdir/$base.tmp"
            mv "$tmpdir/$base.tmp" "$md_file"

            cat > "$typst_file" <<EOF
            #set page(paper: "a4", margin: (left: 10mm, right: 10mm, top: 10mm, bottom: 10mm), numbering: "1")
            #set text(font: "New Computer Modern", size: 14pt, lang: "ru", region: "RU")
            #set par(
              first-line-indent: (amount: 1.25cm, all: true),
              leading: 0.75em,
              justify: true,
              linebreaks: "optimized",
              spacing: 0.75em,
            )
            #set heading(numbering: none, outlined: true, supplement: [Раздел])
            #show heading: it => {
              let sizes = ("1": 18pt, "2": 16pt, "3": 14pt, "4": 14pt)
              let alignments = ("1": left, "2": left, "3": left, "4": left)
              let content = if it.level == 1 { it.body } else { it }
              pad(left: 1.25cm, align(alignments.at(str(it.level)), text(size: sizes.at(str(it.level)), weight: "bold", content)))
            }
            #show heading.where(level: 1): it => {
              counter(math.equation).update(0)
              counter(figure.where(kind: image)).update(0)
              counter(figure.where(kind: table)).update(0)
              counter(figure.where(kind: raw)).update(0)
              it
            }
            // нумерация уравнений
            #set math.equation(numbering: num => "(" + (str(counter(heading).get().at(0)) + "." + str(num)) + ")")
            // нумерация и подпись к рисункам
            #set figure(supplement: [Рисунок], numbering: num => str(counter(heading).get().at(0)) + "." + str(num))
            #show figure.where(kind: raw): set figure(supplement: [Листинг])
            #show figure.where(kind: raw): set figure.caption(position: top)
            #set figure.caption(separator: " ")
            #show figure.caption: it => {
              set par(leading: 0.5em)
              it
            }
            // Подпись к таблицам
            #show figure.where(kind: table): set figure(supplement: [Таблица])
            #show figure: set block(breakable: true)
            #set list(tight: false, marker: ([---], [---], [---]), spacing: 1em, indent: 0.55cm)
            #show list: it => {
              v(0.5em)
              it
            }

            // чтобы ссылки отображались как (число)
            #show ref: it => {
              let eq = math.equation
              let el = it.element
              if el != none and el.func() == eq {
                // Override equation references.
                link(
                  el.location(),
                  numbering(
                    el.numbering,
                    ..counter(eq).at(el.location()),
                  ),
                )
              } else {
                it
              }
            }
            #import "@preview/cmarker:0.1.9"
            #import "@preview/mitex:0.2.7": mitex
            #import "@preview/codly:1.3.0": *
            #import "@preview/codly-languages:0.1.10": *
            #show: codly-init.with()
            #codly(languages: codly-languages)
            #cmarker.render(read("$base"), math: mitex)
            EOF

            (cd "$tmpdir" && typst compile "$name.typ" "$name.pdf")
            rm -f "$typst_file" "$md_file"

            nohup zathura "$pdf_file" >/dev/null 2>&1 &
          '';
        }
      )
    ];
    home.persistence."/persist".directories = [
      ".cache/typst"
      ".local/share/typst"
    ];
  };
}
