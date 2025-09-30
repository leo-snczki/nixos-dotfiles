{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      ytdl-format = "bestvideo[vcodec^=avc1][height<=1080]+bestaudio/bestvideo[vcodec^=avc1][height<=720]+bestaudio/anyvideo+anyaudio";
    };
  };
}