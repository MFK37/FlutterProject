class Player {
  String playerName;
  int playerScore;

  Player(this.playerName, this.playerScore);

  void playGame() {
    print('$playerName is playing the game.');
  }

  void chooseLevel(int level) {
    print('$playerName is choosing level $level.');
  }

  void increaseScore() {
    playerScore += 10;
    print('$playerName earned 10 points. Total score: $playerScore');
  }
}

class GameConsole {
  String consoleName;
  List<String> supportedGames;

  GameConsole(this.consoleName, this.supportedGames);

  void powerOn() {
    print('$consoleName is powering on.');
  }

  void loadGame(String gameTitle) {
    if (supportedGames.contains(gameTitle)) {
      print('$consoleName is loading $gameTitle.');
    } else {
      print('$consoleName does not support $gameTitle.');
    }
  }

  void saveGameProgress() {
    print('$consoleName is saving game progress.');
  }
}

class GameLevel {
  int levelNumber;
  String levelDescription;

  GameLevel(this.levelNumber, this.levelDescription);

  void displayLevelInfo() {
    print('Level $levelNumber: $levelDescription');
  }

  void startLevel() {
    print('Starting Level $levelNumber.');
  }

  void completeLevel() {
    print('Level $levelNumber completed!');
  }
}
