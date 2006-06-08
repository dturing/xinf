%module SDL

typedef unsigned int Uint32;
typedef unsigned int Uint16;
typedef signed int Sint16;
typedef unsigned char Uint8;

typedef unsigned int SDLKey;
typedef unsigned int SDLMod;
typedef unsigned int SDL_GLattr;

#define DECLSPEC
#define SDLCALL

%include <SDL.h>
%include <SDL_keysym.h>
%include <SDL_keyboard.h>
%include <SDL_events.h>
%include <SDL_video.h>
%include <SDL_version.h>

SDL_Event *_NewEvent();
