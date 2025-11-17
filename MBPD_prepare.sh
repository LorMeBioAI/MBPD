unzip ./db/pathogen.fasta.zip ./db/
#tar -zxvf ./db/silva_MBPD.fasta.tar.gz

# create launcher
#cat << 'EOF' > MBPD
##!/usr/bin/env bash
#SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
#SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
#python "$SCRIPT_DIR/MBPD.py" "$@"
#EOF
chmod +x MBPD

#cat << 'EOF' > MBPD2
##!/usr/bin/env bash
#SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
#SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
#python "$SCRIPT_DIR/MBPD2.py" "$@"
#EOF
#chmod +x MBPD2

cat << 'EOF' > MBPD_integrated
#!/usr/bin/env bash
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
python "$SCRIPT_DIR/MBPD_integrated.py" "$@"
EOF
chmod +x MBPD_integrated

# link to conda bin
if [ -z "$CONDA_PREFIX" ]; then
    echo "[ERROR] Please activate your conda environment before running this script."
    exit 1
fi

#ln -sf "$(realpath ./MBPD)" "$CONDA_PREFIX/bin/MBPD"
#ln -sf "$(realpath ./MBPD2)" "$CONDA_PREFIX/bin/MBPD"
ln -sf "$(realpath ./MBPD_integrated)" "$CONDA_PREFIX/bin/MBPD"
