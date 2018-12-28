#include "game.h"

Game::Game()
{
    int n;
    for(int i = 0; i < 16; i++)
    {
            do n = rand() % 15 + 1;
            while (this->gameField.contains(n));
            this->gameField.append(n);
    }
}
QList<int> Game::getGameField()
{
    return this->gameField;
}
