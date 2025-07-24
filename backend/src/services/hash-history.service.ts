export interface HashOperation {
    id: string;
    value: string;
    hash: string;
    timestamp: Date;
    algorithm: string;
}

class HashHistoryService {
    private history: HashOperation[] = [];

    logHashOperation(value: string, hash: string, algorithm: string = 'md5'): void {
        const operation: HashOperation = {
            id: this.generateId(),
            value,
            hash,
            timestamp: new Date(),
            algorithm
        };

        this.history.push(operation);

        if (this.history.length > 1000) {
            this.history.shift();
        }
    }

    getHistory(): HashOperation[] {
        return [...this.history];
    }

    getRecentOperations(limit: number = 10): HashOperation[] {
        return this.history.slice(-limit).reverse();
    }

    clearHistory(): void {
        this.history = [];
    }

    private generateId(): string {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }
}

const hashHistoryService = new HashHistoryService();
export default hashHistoryService;