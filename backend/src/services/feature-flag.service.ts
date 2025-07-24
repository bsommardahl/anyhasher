export interface FeatureFlag {
    name: string;
    enabled: boolean;
    description?: string;
}

class FeatureFlagService {
    private flags: Map<string, boolean> = new Map();

    constructor() {
        this.initializeFlags();
    }

    private initializeFlags(): void {
        const flagPrefix = 'FEATURE_';

        for (const [key, value] of Object.entries(process.env)) {
            if (key.startsWith(flagPrefix)) {
                const flagName = key.substring(flagPrefix.length).toLowerCase();
                this.flags.set(flagName, value === 'true');
            }
        }

        this.setDefaultFlags();
    }

    private setDefaultFlags(): void {
        if (!this.flags.has('enhanced_response')) {
            this.flags.set('enhanced_response', false);
        }
        if (!this.flags.has('hash_history')) {
            this.flags.set('hash_history', false);
        }
    }

    isEnabled(flagName: string): boolean {
        return this.flags.get(flagName.toLowerCase()) || false;
    }

    enableFlag(flagName: string): void {
        this.flags.set(flagName.toLowerCase(), true);
        process.env[`FEATURE_${flagName.toUpperCase()}`] = 'true';
    }

    disableFlag(flagName: string): void {
        this.flags.set(flagName.toLowerCase(), false);
        process.env[`FEATURE_${flagName.toUpperCase()}`] = 'false';
    }

    getAllFlags(): FeatureFlag[] {
        return Array.from(this.flags.entries()).map(([name, enabled]) => ({
            name,
            enabled,
            description: this.getFlagDescription(name)
        }));
    }

    private getFlagDescription(flagName: string): string {
        const descriptions = {
            enhanced_response: 'Returns hash with additional metadata',
            hash_history: 'Enables hash operation logging'
        };
        return descriptions[flagName] || 'No description available';
    }
}

const featureFlagService = new FeatureFlagService();
export default featureFlagService;