import csv
import random
import uuid
from datetime import datetime, timedelta

providers = {
    "OpenAI": ["GPT-4.1", "GPT-4o"],
    "Gemini": ["Gemini-2.5-Pro", "Gemini-2.5-Flash"],
    "Anthropic": ["Claude-4-Sonnet"],
    "Vertex AI": ["Gemini-on-Vertex"],
    "GitHub Copilot": ["Copilot-Chat"]
}

teams = [
    "Platform",
    "SRE",
    "Security",
    "Data Engineering",
    "Product Engineering",
    "Customer Support"
]

projects = [
    "aiopsvista",
    "support-assistant",
    "incident-platform",
    "rag-platform",
    "developer-portal",
    "security-copilot"
]

workflows = [
    "Incident Analysis",
    "Root Cause Analysis",
    "Code Review",
    "Documentation",
    "Customer Support",
    "Knowledge Search",
    "CI/CD Assistant"
]

agents = [
    "Incident Agent",
    "Security Agent",
    "FinOps Agent",
    "Support Agent",
    "Code Assistant",
    "Platform Agent"
]

statuses = ["success"] * 95 + ["error"] * 3 + ["timeout"] + ["rate_limited"]
environments = ["prod"] * 70 + ["stage"] * 20 + ["dev"] * 10

outfile = "platform/analytics/sample-data/ai_usage_sample.csv"

provider_count = {}
team_count = {}
status_count = {}

with open(outfile, "w", newline="") as f:
    writer = csv.writer(f)

    writer.writerow([
        "event_timestamp",
        "provider",
        "model",
        "request_id",
        "user_id",
        "project_id",
        "team_name",
        "workflow_name",
        "agent_name",
        "request_count",
        "input_tokens",
        "output_tokens",
        "total_tokens",
        "estimated_cost",
        "latency_ms",
        "status",
        "environment"
    ])

    for _ in range(1000):

        provider = random.choice(list(providers.keys()))
        model = random.choice(providers[provider])

        input_tokens = random.randint(100, 8000)
        output_tokens = random.randint(50, 4000)
        total_tokens = input_tokens + output_tokens

        estimated_cost = round(total_tokens * 0.00001, 5)

        timestamp = datetime.utcnow() - timedelta(
            days=random.randint(0, 30),
            minutes=random.randint(0, 1440)
        )

        team = random.choice(teams)
        status = random.choice(statuses)

        provider_count[provider] = provider_count.get(provider, 0) + 1
        team_count[team] = team_count.get(team, 0) + 1
        status_count[status] = status_count.get(status, 0) + 1

        writer.writerow([
            timestamp.isoformat(),
            provider,
            model,
            str(uuid.uuid4()),
            f"user-{random.randint(1,50)}",
            random.choice(projects),
            team,
            random.choice(workflows),
            random.choice(agents),
            1,
            input_tokens,
            output_tokens,
            total_tokens,
            estimated_cost,
            random.randint(150,5000),
            status,
            random.choice(environments)
        ])

print("Generated 1000 records")
print()

print("Provider Distribution")
for k,v in provider_count.items():
    print(k,":",v)

print()

print("Team Distribution")
for k,v in team_count.items():
    print(k,":",v)

print()

print("Status Distribution")
for k,v in status_count.items():
    print(k,":",v)