import hashHistoryService, { HashOperation } from './hash-history.service';

describe('HashHistoryService', () => {
    beforeEach(() => {
        hashHistoryService.clearHistory();
    });

    it('should log a hash operation', () => {
        hashHistoryService.logHashOperation('test', 'hashed', 'sha256');
        const history = hashHistoryService.getHistory();
        expect(history.length).toBe(1);
        expect(history[0].value).toBe('test');
        expect(history[0].hash).toBe('hashed');
        expect(history[0].algorithm).toBe('sha256');
        expect(typeof history[0].id).toBe('string');
        expect(history[0].timestamp).toBeInstanceOf(Date);
    });

    it('should use default algorithm if not provided', () => {
        hashHistoryService.logHashOperation('foo', 'bar');
        const history = hashHistoryService.getHistory();
        expect(history[0].algorithm).toBe('md5');
    });

    it('should return a copy of the history', () => {
        hashHistoryService.logHashOperation('a', 'b');
        const history1 = hashHistoryService.getHistory();
        history1.push({
            id: 'fake',
            value: 'fake',
            hash: 'fake',
            timestamp: new Date(),
            algorithm: 'fake'
        });
        const history2 = hashHistoryService.getHistory();
        expect(history2.length).toBe(1);
    });

    it('should clear the history', () => {
        hashHistoryService.logHashOperation('x', 'y');
        hashHistoryService.clearHistory();
        expect(hashHistoryService.getHistory().length).toBe(0);
    });

    it('should limit history to 1000 entries', () => {
        for (let i = 0; i < 1005; i++) {
            hashHistoryService.logHashOperation(`v${i}`, `h${i}`);
        }
        const history = hashHistoryService.getHistory();
        expect(history.length).toBe(1000);
        expect(history[0].value).toBe('v5');
    });

    it('should get recent operations with default limit', () => {
        for (let i = 0; i < 15; i++) {
            hashHistoryService.logHashOperation(`v${i}`, `h${i}`);
        }
        const recent = hashHistoryService.getRecentOperations();
        expect(recent.length).toBe(10);
        expect(recent[0].value).toBe('v14');
        expect(recent[9].value).toBe('v5');
    });

    it('should get recent operations with custom limit', () => {
        for (let i = 0; i < 5; i++) {
            hashHistoryService.logHashOperation(`v${i}`, `h${i}`);
        }
        const recent = hashHistoryService.getRecentOperations(3);
        expect(recent.length).toBe(3);
        expect(recent[0].value).toBe('v4');
        expect(recent[2].value).toBe('v2');
    });

    it('should return empty array for recent operations if history is empty', () => {
        const recent = hashHistoryService.getRecentOperations();
        expect(recent).toEqual([]);
    });
});
