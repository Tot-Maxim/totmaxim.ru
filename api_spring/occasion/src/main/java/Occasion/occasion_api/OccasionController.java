package Occasion.occasion_api;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/occasion")
public class OccasionController {

    @Autowired
    private OccasionRepository occasionRepository;

    @GetMapping("/{number}")
    public String getOccasion(@PathVariable Long number) {
        Optional<Occasion> occasion = occasionRepository.findById(number+1);
        return occasion.map(Occasion::getTaskDescription)
                .orElse("Задача не найдена!");
    }

    // Метод для добавления новой задачи
    @PostMapping("/add")
    public ResponseEntity<Occasion> addOccasion(@RequestBody Occasion occasion) {
        Occasion savedOccasion = occasionRepository.save(occasion);
        return ResponseEntity.ok(savedOccasion);
    }
}

