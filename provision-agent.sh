#!/usr/bin/env bash
set -euo pipefail

CONFIG="${1:?Usage: $0 <config.json>}"
BASE="./hermes-agent-custom"

if [ ! -f "$CONFIG" ]; then
  echo "Error: config file not found: $CONFIG" >&2
  exit 1
fi

PROFESSION=$(jq -r '.profession // empty' "$CONFIG")
NAME=$(jq -r '.name // "User"' "$CONFIG")

if [ -z "$PROFESSION" ]; then
  echo "Error: .profession is required in config" >&2
  exit 1
fi

rm -rf "$BASE"
mkdir -p "$BASE/memories" "$BASE/skills"

cat > "$BASE/.env" << 'EOF'
DEEPSEEK_API_KEY=YOUR_API_KEY_HERE
EOF

cat > "$BASE/config.yaml" << 'EOF'
provider: deepseek
model: deepseek-v4-flash
skills_dir: ./skills/
EOF

cat > "$BASE/memories/USER.md" << PROFEOF
# $NAME

Profession: $PROFESSION
Last updated: $(date +%Y-%m-%d)
PROFEOF

cat > "$BASE/memories/MEMORY.md" << PROFEOF
# Session Context

User is a $PROFESSION professional using Hermes Agent.
Preferences: concise Chinese responses, professional tone.
Setup date: $(date +%Y-%m-%d)
PROFEOF

write_skill() {
  local file="$1" name="$2" desc="$3" triggers="$4" steps="$5"
  cat > "$BASE/skills/$file" << SKILLEOF
---
name: $name
description: $desc
trigger_phrases:
$triggers
---

$steps
SKILLEOF
}

case "$PROFESSION" in
  teacher)
    write_skill "lesson-planning.md" "Lesson Planning" \
      "Design structured lesson plans aligned with curriculum standards" \
"  - 写教案
  - lesson plan
  - 备课
  - 教学设计" \
"1. Ask the user for the subject, grade level, and topic of the lesson.
2. Determine the lesson duration and any specific curriculum standards to align with.
3. Structure the plan: learning objectives, materials, introduction, main activities, assessment, closure.
4. Include differentiation suggestions for varying student levels.
5. Review with the user and adjust based on feedback."

    write_skill "worksheet-gen.md" "Worksheet Generator" \
      "Generate practice worksheets, quizzes, and homework assignments" \
"  - 练习题
  - worksheet
  - 试卷
  - 作业" \
"1. Ask the user for subject, grade, topic, and question count.
2. Determine question types (multiple choice, fill-in-blank, short answer, essay).
3. Generate questions at appropriate difficulty with an answer key.
4. Format clearly with instructions for students.
5. Review and adjust based on user feedback."

    write_skill "parent-comm.md" "Parent Communication" \
      "Draft parent emails, progress reports, and meeting notes" \
"  - 家长沟通
  - parent email
  - 家长会
  - 家校联系" \
"1. Identify the purpose: progress update, behavior concern, event announcement, or meeting request.
2. Ask about the student's recent performance and specific points to highlight.
3. Draft a professional, empathetic message in Chinese.
4. Offer translation or bilingual version if needed.
5. Confirm tone and content with the user before finalizing."
    ;;

  lawyer)
    write_skill "contract-review.md" "Contract Review" \
      "Analyze contracts for risk, ambiguous language, and missing clauses" \
"  - 审合同
  - contract review
  - 合同审查
  - 条款分析" \
"1. Ask the user for the contract type and key concerns.
2. Review the contract section by section: parties, definitions, scope, payment, term, termination, liability, dispute resolution.
3. Flag ambiguous language, missing clauses, and unbalanced terms.
4. Provide specific revision suggestions with rationale.
5. Summarize overall risk level and recommended actions."

    write_skill "legal-memo.md" "Legal Memo Writing" \
      "Draft legal memoranda on statutory or case law questions" \
"  - 法律备忘录
  - legal memo
  - 法律分析
  - 法律意见书" \
"1. Ask the user for the legal question and relevant jurisdiction.
2. Identify applicable statutes, regulations, and precedents.
3. Structure the memo: issue, brief answer, facts, analysis, conclusion.
4. Cite relevant sources with proper references.
5. Review for accuracy and completeness with the user."

    write_skill "compliance-checklist.md" "Compliance Checklist" \
      "Generate compliance checklists for regulatory requirements" \
"  - 合规检查
  - compliance
  - 合规清单
  - 法规审查" \
"1. Ask the user for the applicable regulatory framework and business context.
2. Identify all relevant compliance obligations.
3. Organize into a checklist by category with citations.
4. Add risk level indicators and remediation suggestions.
5. Provide a tracking mechanism for completion status."
    ;;

  realestate)
    write_skill "property-analysis.md" "Property Analysis" \
      "Analyze property valuations, market comps, and investment potential" \
"  - 房产分析
  - property analysis
  - 房产估值
  - 投资分析" \
"1. Ask the user for property details: location, size, age, type, asking price.
2. Gather comparable sales data and market trends.
3. Calculate key metrics: price per sqm, cap rate, ROI, days on market.
4. Identify strengths, weaknesses, opportunities, and risks.
5. Present a clear buy/hold/sell recommendation with reasoning."

    write_skill "market-report.md" "Market Report" \
      "Generate real estate market reports and trend analyses" \
"  - 市场报告
  - market report
  - 楼市分析
  - 行情报告" \
"1. Ask the user for the geographic area, property type, and time horizon.
2. Compile relevant market data: transaction volume, average price, inventory levels.
3. Analyze trends and identify patterns.
4. Structure the report: executive summary, data analysis, neighborhood insights, forecast.
5. Highlight actionable takeaways for buyers, sellers, or investors."

    write_skill "client-comm.md" "Client Communication" \
      "Draft property listings, offer letters, and client updates" \
"  - 客户沟通
  - listing description
  - 房源描述
  - 客户跟进" \
"1. Determine the purpose: listing description, offer letter, or status update.
2. Gather property highlights, unique features, and selling points.
3. Draft persuasive, accurate copy tailored to the target audience.
4. Include key details: price, location, size, amenities, nearby attractions.
5. Review tone and accuracy with the user."
    ;;

  consultant)
    write_skill "analysis-framework.md" "Analysis Framework" \
      "Apply structured frameworks to business problems" \
"  - 分析框架
  - SWOT analysis
  - 战略分析
  - 商业分析" \
"1. Ask the user for the business problem, context, and objectives.
2. Select appropriate framework (SWOT, Porter's Five Forces, MECE, issue tree, etc.).
3. Apply the framework systematically, populating each component.
4. Identify key insights, gaps, and recommended actions.
5. Present findings with clear visuals or structured summary."

    write_skill "presentation-gen.md" "Presentation Generator" \
      "Build slide decks, executive summaries, and pitch decks" \
"  - 做PPT
  - presentation
  - 汇报材料
  - 演讲" \
"1. Ask for the presentation purpose, audience, and key message.
2. Structure the narrative arc: hook, problem, analysis, solution, call to action.
3. Generate slide-by-slide content with headlines, bullet points, and data suggestions.
4. Recommend visual elements: charts, diagrams, images.
5. Provide speaker notes for each slide."

    write_skill "client-deliverable.md" "Client Deliverable" \
      "Prepare professional client-ready reports and proposals" \
"  - 交付物
  - deliverable
  - 咨询报告
  - 项目建议书" \
"1. Ask for the engagement scope, client industry, and deliverable type.
2. Structure: executive summary, methodology, findings, recommendations, appendix.
3. Ensure professional formatting and client-appropriate language.
4. Include data-driven insights with clear visualizations.
5. Add a next-steps section with proposed timeline and owners."
    ;;

  freelancer)
    write_skill "proposal-gen.md" "Proposal Generator" \
      "Create winning project proposals and bids" \
"  - 写方案
  - proposal
  - 投标书
  - 项目方案" \
"1. Ask the user for the project scope, client requirements, and budget range.
2. Structure the proposal: understanding of need, approach, methodology, timeline, pricing.
3. Highlight the user's unique value proposition and relevant experience.
4. Include clear deliverables, milestones, and payment terms.
5. Review for persuasiveness and clarity."

    write_skill "contract-mgmt.md" "Contract Management" \
      "Draft and review freelance service agreements and SOWs" \
"  - 合同管理
  - contract
  - 服务协议
  - SOW" \
"1. Ask for the project type, scope, duration, and payment structure.
2. Draft key sections: scope of work, deliverables, timeline, fees, revision policy, IP rights.
3. Flag common risks: scope creep, late payment, unclear acceptance criteria.
4. Provide negotiation tips for favorable terms.
5. Review the final contract for completeness and clarity."

    write_skill "client-outreach.md" "Client Outreach" \
      "Draft cold emails, follow-ups, and networking messages" \
"  - 客户开发
  - outreach
  - 开发信
  - 跟进" \
"1. Determine the target client, industry, and outreach goal.
2. Research the client's pain points and relevant context.
3. Draft a personalized message with a clear value proposition.
4. Include a specific, low-friction call to action.
5. Offer follow-up sequence options for non-responses."
    ;;
esac

echo "Done. Hermes agent created at: $BASE"
echo "Profession: $PROFESSION"
