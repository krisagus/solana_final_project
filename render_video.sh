#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# Localizar binario ffmpeg (prioriza ~/.local/bin/ffmpeg)
if [ -x "$HOME/.local/bin/ffmpeg" ]; then
    FFMPEG_BIN="$HOME/.local/bin/ffmpeg"
elif command -v ffmpeg &>/dev/null; then
    FFMPEG_BIN="$(command -v ffmpeg)"
else
    echo "Error: No se encontró ffmpeg instalado."
    exit 1
fi

INPUT_VIDEO="${1:-demo.mp4}"
SUBTITLES="${2:-subtitulos.srt}"
OUTPUT_VIDEO="${3:-demo_final.mp4}"

if [ ! -f "$INPUT_VIDEO" ]; then
    echo "Error: El archivo de video de entrada '$INPUT_VIDEO' no existe."
    echo "Uso: ./render_video.sh [video_entrada.mp4] [subtitulos.srt] [video_salida.mp4]"
    exit 1
fi

if [ ! -f "$SUBTITLES" ]; then
    echo "Error: El archivo de subtítulos '$SUBTITLES' no existe."
    exit 1
fi

echo "=========================================================="
echo "Procesando video con subtítulos quemados (Hardcoded Subs)..."
echo "Entrada:     $INPUT_VIDEO"
echo "Subtítulos:  $SUBTITLES"
echo "Salida:      $OUTPUT_VIDEO"
echo "FFmpeg:      $FFMPEG_BIN"
echo "=========================================================="

# Estilo de subtítulos ASS:
# - FontSize: 20
# - PrimaryColour: Blanco (&H00FFFFFF)
# - BorderStyle: 3 (Caja/Fondo semitransparente)
# - BackColour: Negro con ~70% opacidad (&HB0000000)
# - Alignment: 2 (Centro abajo)
# - MarginV: 35
SUB_FILTER="subtitles=${SUBTITLES}:force_style='Fontname=Sans,FontSize=20,PrimaryColour=&H00FFFFFF,OutlineColour=&H00000000,BackColour=&HB0000000,BorderStyle=3,Outline=0,Shadow=0,Alignment=2,MarginV=35'"

"$FFMPEG_BIN" -y -i "$INPUT_VIDEO" \
    -vf "$SUB_FILTER" \
    -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    "$OUTPUT_VIDEO"

echo "=========================================================="
echo "¡Renderizado completo exitosamente!"
echo "Archivo listo: $DIR/$OUTPUT_VIDEO"
echo "=========================================================="
