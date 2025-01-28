package Cow_and_Bull_game_spring;

import java.util.List;


public class GameStatus {
    private final String secretNumber;
    private final List<String> trying;
    private final int attemptsLeft;
    private final boolean gameActive;

    public GameStatus(String secretNumber, List<String> trying, int attemptsLeft, boolean gameActive) {
        this.secretNumber = secretNumber;
        this.trying = trying;
        this.attemptsLeft = attemptsLeft;
        this.gameActive = gameActive;
    }

    // Getters
    public String getSecretNumber() {
        return secretNumber;
    }

    public List<String> getTrying() {
        return trying;
    }

    public int getAttemptsLeft() {
        return attemptsLeft;
    }

    public boolean isGameActive() {
        return gameActive;
    }
}