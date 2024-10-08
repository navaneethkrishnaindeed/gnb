# Flutter App with Riverpod, Hive, and Domain-Driven Design

This Flutter application demonstrates the use of Riverpod for dependency injection, Hive for local storage, and follows Domain-Driven Design (DDD) principles.

## Prerequisites

Before running the app, ensure you have the following installed:

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for Android / iOS development)

## Getting Started

1. Clone the repository:
   ```
   git clone https://github.com/navaneethkrishnaindeed/gnb.git
   ```

2. Navigate to the project directory:
   ```
   cd gnb
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Dependencies

This app uses the following main dependencies:

- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) for dependency injection and state management
- [hive](https://pub.dev/packages/hive) for local storage
- [hive_flutter](https://pub.dev/packages/hive_flutter) for Flutter-specific Hive functionality

Check `pubspec.yaml` for the complete list of dependencies and their versions.

## Project Structure

The project follows a Domain-Driven Design architecture:

```
lib/
  ├── application/      # Application layer (Use cases, DTOs)
  ├── domain/           # Domain layer (Entities, Value Objects, Repository Interfaces)
  ├── infrastructure/   # Infrastructure layer (Repository Implementations, External Services)
  ├── presentation/     # Presentation layer (UI, ViewModels)
  │   ├── pages/        
  │   └── widgets/      
  ├── shared/           # Shared kernel (Common functionality)
  └── main.dart         # Entry point of the application
```

## Domain-Driven Design (DDD) Implementation

This project adheres to DDD principles:

1. **Domain Layer**: Contains the core business logic, entities, value objects, and repository interfaces. This layer is independent of any external frameworks or libraries.

2. **Application Layer**: Implements use cases that orchestrate the flow of data to and from the domain entities. It depends on the domain layer but has no dependencies on outer layers.

3. **Infrastructure Layer**: Provides concrete implementations of the repository interfaces defined in the domain layer. It's responsible for data persistence and external service integration.

4. **Presentation Layer**: Handles the UI and user interactions. It uses Riverpod to manage state and dependencies.

## Riverpod Usage

Riverpod is used for dependency injection and state management. Providers are defined within their respective layers, typically in the application and presentation layers.

## Hive Usage

Hive is used for local storage, primarily implemented in the infrastructure layer. Hive objects correspond to domain entities and are used in repository implementations.

## Specific Considerations

1. **Separation of Concerns**: Maintain clear boundaries between layers. The domain layer should not depend on outer layers or external libraries.

2. **Dependency Injection**: Use Riverpod to inject dependencies, allowing for better testability and flexibility.

3. **Repository Pattern**: Implement repository interfaces in the domain layer and their concrete implementations in the infrastructure layer.

4. **Immutability**: Prefer immutable entities and value objects in the domain layer for better consistency and predictability.

5. **Use Cases**: Define clear use cases in the application layer to encapsulate business logic operations.

6. **Error Handling**: Implement domain-specific exceptions and handle them appropriately in outer layers.

7. **Mapping**: Use mappers or adapters when transferring data between layers, especially between domain entities and DTOs or persistence models.

8. **Testing**: Write unit tests for each layer, with a focus on domain logic and use cases.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.