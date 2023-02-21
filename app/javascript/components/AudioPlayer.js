import React, { useState, useRef } from 'react';

function AudioPlayer({ articleId }) {
  const [isPlaying, setIsPlaying] = useState(false);
  const audioRef = useRef(null);

  const handlePlay = () => {
    setIsPlaying(true);
    audioRef.current.play();
  };

  const handlePause = () => {
    setIsPlaying(false);
    audioRef.current.pause();
  };

  return (
    <>
      {isPlaying ? (
        <button onClick={handlePause}>Pause</button>
      ) : (
        <button onClick={handlePlay}>Play</button>
      )}
      <audio ref={audioRef} src={`/path/to/audio/files/${articleId}.mp3`} />
    </>
  );
}

export default AudioPlayer;
