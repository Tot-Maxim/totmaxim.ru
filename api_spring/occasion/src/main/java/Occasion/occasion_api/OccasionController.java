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

import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Timer;

@RestController
@RequestMapping("/occasion")
public class OccasionController {

    @Autowired
    private OccasionRepository occasionRepository;

    private final Counter addOccasionsCounter;
    private final Counter getOccasionsCounter;
    private final Timer getOccasionTimer;
    private final Timer addOccasionTimer;

    // Внедрение MeterRegistry для метрик
    public OccasionController(MeterRegistry meterRegistry) {
        this.addOccasionsCounter = meterRegistry.counter("occasions.add");
        this.getOccasionsCounter = meterRegistry.counter("occasions.get");
        this.getOccasionTimer = meterRegistry.timer("occasions.get.timer");
        this.addOccasionTimer = meterRegistry.timer("occasions.add.timer");
    }

    @GetMapping("/{number}")
    public String getOccasion(@PathVariable Long number) {
        getOccasionsCounter.increment();
        return getOccasionTimer.record(() -> {
            Optional<Occasion> occasion = occasionRepository.findById(number + 1);
            return occasion.map(Occasion::getTaskDescription)
                    .orElse("Задача не найдена!");
        });
    }

    // Метод для добавления новой задачи
    @PostMapping("/add")
    public ResponseEntity<Occasion> addOccasion(@RequestBody Occasion occasion) {
        addOccasionsCounter.increment();
        return addOccasionTimer.record(() -> {
            Occasion savedOccasion = occasionRepository.save(occasion);
            return ResponseEntity.ok(savedOccasion);
        });
    }
}

