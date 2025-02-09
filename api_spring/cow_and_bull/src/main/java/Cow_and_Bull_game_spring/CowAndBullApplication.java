package Cow_and_Bull_game_spring;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@SpringBootApplication
@RestController
@RequestMapping("/api/game")
public class CowAndBullApplication {

    private final GameState gameState = new GameState();

	public static void main(String[] args) {
		SpringApplication.run(CowAndBullApplication.class, args);
	}

	@PostMapping("/start")
    public ResponseEntity<String> startNewGame() {
        System.out.println("Starting a new game...");
        gameState.startNewGame();
        return ResponseEntity.ok("Игра начата! Загаданное число: " + gameState.getSecretNumber());
    }

    @GetMapping("/status")
    public ResponseEntity<GameStatus> getGameStatus() {
        GameStatus gameStatus = new GameStatus(
            gameState.getSecretNumber(),
            gameState.getTrying(),
            gameState.getAttemptsLeft(),
            gameState.isGameActive()
        );
        return ResponseEntity.ok(gameStatus);
    }

    @GetMapping("/guess")
    public ResponseEntity<Map<String, Object>> makeGuess(@RequestParam String guess) {
        if (!gameState.isGameActive()) {
            return ResponseEntity.status(400).body(Collections.singletonMap("message", "Игра не активна."));
        }

        gameState.trying.add(guess);

        if (guess.equals(gameState.secretNumber)) {
            Map<String, Object> response = new HashMap<>();
            response.put("status", "win");
            response.put("secretNumber", gameState.secretNumber);
            return ResponseEntity.ok(response);
        } else {
            gameState.attemptsLeft--;
            if (gameState.attemptsLeft < 0) {
                Map<String, Object> response = new HashMap<>();
                response.put("status", "lose");
                response.put("secretNumber", gameState.secretNumber);
                return ResponseEntity.ok(response);
            } else {
                int[] cowsAndBulls = getCowsAndBulls(gameState.secretNumber, guess);
                Map<String, Object> response = new HashMap<>();
                response.put("status", "continue");
                response.put("cows", cowsAndBulls[0]);
                response.put("bulls", cowsAndBulls[1]);
                response.put("attemptsLeft", gameState.attemptsLeft);
                response.put("trying", gameState.trying);
                return ResponseEntity.ok(response);
            }
        }
    }


    private int[] getCowsAndBulls(String secret, String guess) {
        int bulls = 0;
        int cows = 0;
        boolean[] checkedSecret = new boolean[4];
        boolean[] checkedGuess = new boolean[4];

        // Check for bulls
        for (int i = 0; i < 4; i++) {
            if (secret.charAt(i) == guess.charAt(i)) {
                bulls++;
                checkedSecret[i] = true;
                checkedGuess[i] = true;
            }
        }

        // Check for cows
        for (int i = 0; i < 4; i++) {
            if (!checkedGuess[i]) {
                for (int j = 0; j < 4; j++) {
                    if (i != j && secret.charAt(i) == guess.charAt(j) && !checkedSecret[j]) {
                        cows++;
                        checkedSecret[j] = true;
                        break;
                    }
                }
            }
        }

        return new int[]{cows, bulls};
    }

    private static class GameState {
        private String secretNumber;
        private int attemptsLeft;
        private boolean gameActive;
        private final List<String> trying = new ArrayList<>();

        public void startNewGame() {
            this.secretNumber = generateUniqueNumber();
            this.attemptsLeft = 10;
            this.gameActive = true;
            this.trying.clear();
        }

        private String generateUniqueNumber() {
            StringBuilder number = new StringBuilder();
            Set<Character> digits = new HashSet<>();

            while (number.length() < 4) {
                char digit = (char) ('0' + (int) (Math.random() * 10));
                if (digits.add(digit)) {
                    number.append(digit);
                }
            }

            return number.toString();
        }

        // Getters для отображения на фронтенде
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
}