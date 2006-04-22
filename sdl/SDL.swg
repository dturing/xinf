%module SDL

%{
#include <SDL.h>

extern vkind neko_k_p_SDL_Event;
DEFINE_KIND( neko_k_p_p_SDL_Rect );

SDL_Event *NewEvent() {
    SDL_Event *event = (SDL_Event*)malloc(sizeof(SDL_Event));
    return event;
}

%}

typedef unsigned int Uint32;
typedef unsigned int Uint16;
typedef signed int Sint16;
typedef unsigned char Uint8;
typedef unsigned int SDLKey;
#define DECLSPEC
#define SDLCALL

%include <SDL.h>
%include <SDL_keyboard.h>
%include <SDL_keysym.h>
%include <SDL_events.h>
%include <SDL_timer.h>
%include <SDL_video.h>

SDL_Event *NewEvent();
