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
        const flagPrefix = 'FEATURE_'; // e.g. FEATURE_ENHANCED_RESPONSE

        for (const [key, value] of Object.entries(process.env)) {
            if (key.startsWith(flagPrefix)) {
                const flagName = key.substring(flagPrefix.length).toLowerCase();
                this.flags.set(flagName, value === 'true');
            }
        }        
    }

    isEnabled(flagName: string): boolean {
        return this.flags.get(flagName.toLowerCase()) || false;
    }

    getAllFlags(): FeatureFlag[] {
        return Array.from(this.flags.entries()).map(([name, enabled]) => ({
            name,
            enabled
        }));
    }    
}

const featureFlagService = new FeatureFlagService();
export default featureFlagService;